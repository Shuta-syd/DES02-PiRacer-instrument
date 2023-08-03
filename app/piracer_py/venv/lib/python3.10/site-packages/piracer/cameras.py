# Copyright (C) 2022 twyleg
import os
import cv2

class Camera:

    def __init__(self, device_path='/dev/video0', rotation=180):
        self.video_capture = cv2.VideoCapture(device_path)
        os.system(f'v4l2-ctl -d {device_path} --set-ctrl=rotate={rotation}')

    def __del__(self):
        self.video_capture.release()

    def read_image(self):
        ret, frame = self.video_capture.read()
        return frame

class MonochromeCamera(Camera):

    def __init__(self, device_path='/dev/video0', rotation=180):
        super().__init__(device_path, rotation)
        os.system(f'v4l2-ctl -d {device_path} --set-ctrl=color_effects=1') # Run 'v4l2-ctl -L' for explanations

