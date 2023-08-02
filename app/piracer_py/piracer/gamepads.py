# Copyright (C) 2022 twyleg
import array
import struct
import os
from typing import Optional, Tuple


class Vector3f:
    def __init__(self) -> None:
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0


class ShanWanGamepadInput:
    def __init__(self) -> None:
        self.analog_stick_left = Vector3f()
        self.analog_stick_right = Vector3f()
        self.button_l1: Optional[float]
        self.button_l2: Optional[float]
        self.button_r1: Optional[float]
        self.button_r2: Optional[float]
        self.button_x: Optional[bool]
        self.button_a: Optional[bool]
        self.button_b: Optional[bool]
        self.button_y: Optional[bool]
        self.button_select: Optional[bool]
        self.button_start: Optional[bool]
        self.button_home: Optional[bool]


class Joystick(object):
    '''
    Based on the donkeycar project
    MIT License
    https://github.com/autorope/donkeycar/blob/4.3.6.2/donkeycar/parts/controller.py

    An interface to a physical joystick.
    The joystick holds available buttons
    and axis; both their names and values
    and can be polled to state changes.
    '''
    def __init__(self, dev_fn='/dev/input/js0') -> None:
        self.axis_states = {}
        self.button_states = {}
        self.axis_names = {}
        self.button_names = {}
        self.axis_map = []
        self.button_map = []
        self.jsdev = None
        self.dev_fn = dev_fn


    def init(self) -> None:
        """
        Query available buttons and axes given
        a path in the linux device tree.
        """
        try:
            from fcntl import ioctl
        except ModuleNotFoundError:
            self.num_axes = 0
            self.num_buttons = 0
            return False

        if not os.path.exists(self.dev_fn):
            return False

        '''
        call once to setup connection to device and map buttons
        '''
        # Open the joystick device.
        self.jsdev = open(self.dev_fn, 'rb')

        # Get the device name.
        buf = array.array('B', [0] * 64)
        ioctl(self.jsdev, 0x80006a13 + (0x10000 * len(buf)), buf) # JSIOCGNAME(len)
        self.js_name = buf.tobytes().decode('utf-8')

        # Get number of axes and buttons.
        buf = array.array('B', [0])
        ioctl(self.jsdev, 0x80016a11, buf) # JSIOCGAXES
        self.num_axes = buf[0]

        buf = array.array('B', [0])
        ioctl(self.jsdev, 0x80016a12, buf) # JSIOCGBUTTONS
        self.num_buttons = buf[0]

        # Get the axis map.
        buf = array.array('B', [0] * 0x40)
        ioctl(self.jsdev, 0x80406a32, buf) # JSIOCGAXMAP

        for axis in buf[:self.num_axes]:
            axis_name = self.axis_names.get(axis, 'unknown(0x%02x)' % axis)
            self.axis_map.append(axis_name)
            self.axis_states[axis_name] = 0.0

        # Get the button map.
        buf = array.array('H', [0] * 200)
        ioctl(self.jsdev, 0x80406a34, buf) # JSIOCGBTNMAP

        for btn in buf[:self.num_buttons]:
            btn_name = self.button_names.get(btn, 'unknown(0x%03x)' % btn)
            self.button_map.append(btn_name)
            self.button_states[btn_name] = 0

        return True


    def show_map(self) -> None:
        '''
        list the buttons and axis found on this joystick
        '''
        print ('%d axes found: %s' % (self.num_axes, ', '.join(self.axis_map)))
        print ('%d buttons found: %s' % (self.num_buttons, ', '.join(self.button_map)))

    def poll(self) -> Tuple[Optional[str], Optional[int], Optional[bool], Optional[str], Optional[int], Optional[float]]:
        '''
        query the state of the joystick, returns button which was pressed, if any,
        and axis which was moved, if any. button_state will be None, 1, or 0 if no changes,
        pressed, or released. axis_val will be a float from -1 to +1. button and axis will
        be the string label determined by the axis map in init.
        '''
        button_name: Optional[str] = None
        button_number: Optional[int] = None
        button_state: Optional[bool] = None
        axis_name: Optional[str] = None
        axis_number: Optional[int] = None
        axis_val: Optional[float] = None

        if self.jsdev is None:
            return button_name, button_number, button_state, axis_name, axis_number, axis_val

        # Main event loop
        evbuf = self.jsdev.read(8)

        if evbuf:
            tval, value, typev, number = struct.unpack('IhBB', evbuf)

            if typev & 0x80:
                #ignore initialization event
                return button_name, button_number, button_state, axis_name, axis_number, axis_val

            if typev & 0x01:
                button_name = self.button_map[number]
                if button_name:
                    self.button_states[button_name] = value
                    button_number = number
                    button_state = value

            if typev & 0x02:
                axis_name = self.axis_map[number]
                if axis_name:
                    fvalue = value / 32767.0
                    self.axis_states[axis_name] = fvalue
                    axis_number = number
                    axis_val = fvalue

        return button_name, button_number, button_state, axis_name, axis_number, axis_val


class ShanWanGamepad(Joystick):

    def __init__(self)  -> None:
        super(ShanWanGamepad, self).__init__()
        super(ShanWanGamepad, self).init()
        self.gamepad_input = ShanWanGamepadInput()

    def read_data(self) -> ShanWanGamepadInput:
        _, button_number, button_state, _, axis_number, axis_val = super(ShanWanGamepad, self).poll()

        if axis_number == 0:
            self.gamepad_input.analog_stick_left.x = axis_val
        elif axis_number == 1:
            self.gamepad_input.analog_stick_left.y = -axis_val
        elif button_number == 10:
            self.gamepad_input.analog_stick_left.z = button_state

        elif axis_number == 2:
            self.gamepad_input.analog_stick_right.x = axis_val
        elif axis_number == 3:
            self.gamepad_input.analog_stick_right.y = -axis_val
        elif button_number == 11:
            self.gamepad_input.analog_stick_right.z = button_state

        elif button_number == 4:
            self.gamepad_input.button_l1 = button_state
        elif button_number == 6:
            self.gamepad_input.button_l2 = button_state

        elif button_number == 5:
            self.gamepad_input.button_r1 = button_state
        elif button_number == 7:
            self.gamepad_input.button_r2 = button_state

        elif button_number == 2:
            self.gamepad_input.button_a = button_state
        elif button_number == 1:
            self.gamepad_input.button_b = button_state
        elif button_number == 3:
            self.gamepad_input.button_x = button_state
        elif button_number == 0:
            self.gamepad_input.button_y = button_state
        elif button_number == 1:
            self.gamepad_input.button_b = button_state
        elif button_number == 12:
            self.gamepad_input.button_home = button_state
        elif button_number == 8:
            self.gamepad_input.button_select = button_state
        elif button_number == 9:
            self.gamepad_input.button_start = button_state

        return self.gamepad_input
