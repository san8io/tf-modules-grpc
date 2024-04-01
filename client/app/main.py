from __future__ import print_function
# from typing import Union
# import logging
# import asyncio
import sys
import grpc

sys.path.append("/code/app/grpc_compiled")
import hellostreamingworld_pb2
import hellostreamingworld_pb2_grpc

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    print("Will try to greet world ...")
    return {"Hello": "World"}


@app.get("/greet/{user_name}")
async def greet_user(user_name: str):
    print("Will try to greet user async...")
    async with grpc.aio.insecure_channel("server:50051") as channel:
        stub = hellostreamingworld_pb2_grpc.MultiGreeterStub(channel)
        hello_stream = stub.sayHello(
            hellostreamingworld_pb2.HelloRequest(name=user_name)
        )
        count=0
        while True:
            response = await hello_stream.read()
            if response == grpc.aio.EOF:
                break
            count+=1
            print(
                "Greeter client received from direct read: " + response.message
            )  
        return {"name": user_name, "stream_size": count}