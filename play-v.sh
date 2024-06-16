#!/bin/bash

# Check if the script is run with -on argument
if [ "$1" != "-on" ]; then
    echo "Usage: play-v -on"
    exit 1
fi

# Create necessary directories if they don't exist
mkdir -p templates static styles

# Create index.php
cat << 'EOF' > index.php
<!DOCTYPE html>
<html>
<head>
    <title>Video Streaming Server</title>
    <link rel="stylesheet" href="styles/style.css">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            padding-top: 20px;
        }
        .circle {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: #000;
            transition: background-color 0.3s;
            cursor: pointer;
            margin: 0 auto;
        }
        .play-icon {
            width: 0;
            height: 0;
            border-left: 30px solid #fff;
            border-top: 20px solid transparent;
            border-bottom: 20px solid transparent;
            transition: border-left-color 0.3s;
        }
        .circle:hover {
            background-color: blue;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="my-4">Welcome to Video Streaming Server</h1>
        <div class="row">
            <?php
            $videoDir = __DIR__;
            $videos = array_diff(scandir($videoDir), array('.', '..'));
            foreach ($videos as $video) {
                $fileExtension = pathinfo($video, PATHINFO_EXTENSION);
                if (in_array($fileExtension, ['mp4', 'mkv'])) {
                    $fileSize = filesize($video);
                    $fileSizeMB = round($fileSize / (1024 * 1024), 2) . ' MB';

                    // Use ffmpeg to get video metadata (duration and resolution)
                    $output = shell_exec("ffmpeg -i \"$video\" 2>&1 | grep 'Duration\\|Video:'");
                    preg_match('/Duration: (\d+:\d+:\d+\.\d+),/', $output, $duration);
                    preg_match('/, (\d+x\d+)[,\s]/', $output, $resolution);

                    echo '
                    <div class="col-lg-3 col-md-4 col-xs-6 thumb">
                        <div class="card mb-4 shadow-sm">
                            <a href="stream.php?file=' . urlencode($video) . '">
                                <div class="circle">
                                    <div class="play-icon"></div>
                                </div>
                            </a>
                            <div class="card-body">
                                <p class="card-text">' . $video . '</p>
                                <p class="card-text">Duration: ' . ($duration[1] ?? 'N/A') . '</p>
                                <p class="card-text">Size: ' . $fileSizeMB . '</p>
                                <p class="card-text">Resolution: ' . ($resolution[1] ?? 'N/A') . '</p>
                            </div>
                        </div>
                    </div>';
                }
            }
            ?>
        </div>
    </div>
</body>
</html>
EOF

# Create stream.php
cat << 'EOF' > stream.php
<?php
require 'VideoStream.php';

if (isset($_GET['file'])) {
    $file = $_GET['file'];
    $filePath = __DIR__ . '/' . $file;

    if (file_exists($filePath)) {
        $stream = new VideoStream($filePath);
        $stream->start();
    } else {
        echo "File not found!";
    }
} else {
    echo "No file specified!";
}
?>
EOF

# Create VideoStream.php
cat << 'EOF' > VideoStream.php
<?php
class VideoStream
{
    private $path = "";
    private $stream = "";
    private $buffer = 102400;
    private $start  = -1;
    private $end    = -1;
    private $size   = 0;

    function __construct($filePath)
    {
        $this->path = $filePath;
    }

    private function open()
    {
        if (!($this->stream = fopen($this->path, 'rb'))) {
            die('Could not open stream for reading');
        }
    }

    private function setHeader()
    {
        ob_get_clean();
        header("Content-Type: video/mp4");
        header("Cache-Control: max-age=2592000, public");
        header("Expires: ".gmdate('D, d M Y H:i:s', time()+2592000) . ' GMT');
        header("Last-Modified: ".gmdate('D, d M Y H:i:s', @filemtime($this->path)) . ' GMT' );
        $this->start = 0;
        $this->size  = filesize($this->path);
        $this->end   = $this->size - 1;
        header("Accept-Ranges: 0-".$this->end);

        if (isset($_SERVER['HTTP_RANGE'])) {
            $c_start = $this->start;
            $c_end = $this->end;

            list(, $range) = explode('=', $_SERVER['HTTP_RANGE'], 2);
            if (strpos($range, ',') !== false) {
                header('HTTP/1.1 416 Requested Range Not Satisfiable');
                header("Content-Range: bytes $this->start-$this->end/$this->size");
                exit;
            }
            if ($range == '-') {
                $c_start = $this->size - substr($range, 1);
            } else {
                $range = explode('-', $range);
                $c_start = $range[0];
                $c_end = (isset($range[1]) && is_numeric($range[1])) ? $range[1] : $c_end;
            }
            $c_end = ($c_end > $this->end) ? $this->end : $c_end;
            if ($c_start > $c_end || $c_start > $this->size - 1 || $c_end >= $this->size) {
                header('HTTP/1.1 416 Requested Range Not Satisfiable');
                header("Content-Range: bytes $this->start-$this->end/$this->size");
                exit;
            }
            $this->start = $c_start;
            $this->end = $c_end;
            $length = $this->end - $this->start + 1;
            fseek($this->stream, $this->start);
            header('HTTP/1.1 206 Partial Content');
            header("Content-Length: ".$length);
            header("Content-Range: bytes $this->start-$this->end/".$this->size);
        } else {
            header("Content-Length: ".$this->size);
        }  
    }

    private function end()
    {
        fclose($this->stream);
        exit;
    }

    private function stream()
    {
        $i = $this->start;
        set_time_limit(0);
        while(!feof($this->stream) && $i <= $this->end) {
            $bytesToRead = $this->buffer;
            if(($i + $bytesToRead) > $this->end) {
                $bytesToRead = $this->end - $i + 1;
            }
            $data = fread($this->stream, $bytesToRead);
            echo $data;
            flush();
            $i += $bytesToRead;
        }
    }

    public function start()
    {
        $this->open();
        $this->setHeader();
        $this->stream();
        $this->end();
    }
}
?>
EOF

# Create style.css
cat << 'EOF' > styles/style.css
body {
    padding-top: 20px;
}
EOF

# Function to clean up generated files
cleanup() {
    echo "Cleaning up..."
    rm -f index.php stream.php VideoStream.php
    rm -rf static templates styles thumbnails
    echo "Server stopped and files cleaned up."
}

# Trap to handle script exit
trap 'cleanup' EXIT

# Start PHP server and allow stopping with a key press
php -S 0.0.0.0:8000 &

# Display message and wait for key press
echo "If you want to close the server, press Enter or any key."
read -n 1 -s

# Kill the PHP server process
kill $!
