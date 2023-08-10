import socket
import time
import random

server_address = 'localhost'
server_port = 23513

def main():
    soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    soc.bind((server_address, server_port))
    soc.listen(1)
    print(f"Listening on {server_address}:{server_port}")

    while True:
        try:
            conn, addr = soc.accept()
            print(f"Connection from {addr}")

            while True:
                # 속도는 평균 20~40 m/minute 범위
                speed = random.uniform(20, 40)
                # RPM은 최대 500까지
                rpm = random.uniform(0, 500)

                message = f"{speed:.2f},{rpm:.2f}"

                try:
                    conn.sendall(message.encode('utf-8'))
                    print(f"Sent: {message.strip()}")
                except (BrokenPipeError, ConnectionResetError):
                    print("Client disconnected, waiting for another connection")
                    break

                time.sleep(0.5)
        except KeyboardInterrupt:
            print("Server is shutting down")
            break
        finally:
            conn.close()

if __name__ == "__main__":
    main()
