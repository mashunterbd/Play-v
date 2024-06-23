# Play-V

![Play Video ](https://img.shields.io/badge/Play%20Video%20-blueviolet?style=plastic) -
![Latest Version ](https://img.shields.io/badge/Latest%20Version%20-brightgreen?style=flat) -
![Made with](https://img.shields.io/badge/Made%20with-bash-%23000000?style=flat-square&logo=bash&logoColor=white&labelColor=%23ffff00) -
![Thumbnails Support ](https://img.shields.io/badge/Thumbnails%20Support%20-blue?style=flat) -

![Blue Dynamic Fashion Special Sale Banner](https://github.com/mashunterbd/Play-v/assets/108648096/9f2ce63a-0c5a-42b9-a52f-a35caa74c6bf) || ![Made by @mashunter](https://img.shields.io/badge/Made%20by%20%40mashunter-pink?style=flat-square)

Your own video streaming server for private network 

# About this tool 
The tools created in the `play-v.sh` script, along with associated PHP and CSS files, offer several benefits and advanced functionalities for managing and streaming video content. Here’s a detailed list of their benefits and functionalities:

![Screenshot 2024-06-16 012535](https://github.com/mashunterbd/Play-v/assets/108648096/5a63ba63-511f-42d5-b250-2b3044750a3f)


1. **Video Streaming Server Setup:**
   - **Benefit:** Enables setting up a local web server for streaming video files.
   - **Functionality:** Utilizes PHP for handling video file metadata and streaming functionality.

2. **Dynamic Video Listing:**
   - **Benefit:** Automatically lists video files in a specified directory.
   - **Functionality:** Uses PHP to scan and filter video files based on file extension (e.g., `mp4`, `mkv`).

3. **Video Metadata Retrieval:**
   - **Benefit:** Displays video metadata such as duration, file size, and resolution.
   - **Functionality:** Uses `ffmpeg` command-line tool via PHP to extract and display metadata dynamically.

4. **Responsive Web Interface:**
   - **Benefit:** Provides a user-friendly web interface for browsing and selecting videos.
   - **Functionality:** Uses Bootstrap CSS framework for responsive design, ensuring compatibility across devices.

5. **Video Streaming Capability:**
   - **Benefit:** Enables users to stream selected videos directly from the server.
   - **Functionality:** Implements a custom PHP class (`VideoStream.php`) to handle video streaming, including range requests for efficient streaming playback.

6. **Error Handling and Feedback:**
   - **Benefit:** Provides informative error messages for file not found or unspecified file requests.
   - **Functionality:** Includes error handling in PHP scripts (`stream.php`) to manage file existence checks and responses.

7. **Clean and Modular Code Structure:**
   - **Benefit:** Facilitates easy maintenance and extension of functionality.
   - **Functionality:** Organizes code into separate PHP files (`index.php`, `stream.php`, `VideoStream.php`) and CSS (`style.css`), promoting readability and modularity.

8. **Streaming Optimization:**
   - **Benefit:** Optimizes video streaming performance through buffered streaming and partial content support.
   - **Functionality:** Implements PHP headers (`Content-Length`, `Content-Range`, `Accept-Ranges`) for efficient streaming and responsiveness to client requests.

9. **Interactive Server Management:**
   - **Benefit:** Allows starting and stopping the PHP web server with ease.
   - **Functionality:** Includes a control mechanism in Bash (`play-v.sh`) to start the PHP server (`php -S`) and cleanly shut it down upon user input.

10. **Educational and Testing Purposes:**
    - **Benefit:** Ideal for learning about web server setup, video streaming mechanisms, and PHP scripting.
    - **Functionality:** Provides a sandbox environment for experimenting with video streaming techniques and web development skills.

These tools collectively provide a robust framework for setting up a video streaming server locally, facilitating dynamic video management, and enhancing user interaction through a responsive web interface. They are beneficial for developers, educators, and hobbyists looking to explore multimedia streaming capabilities or integrate similar functionalities into their projects.
