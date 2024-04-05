from __future__ import print_function
import logging
import sys

from google.rpc import error_details_pb2
import grpc
from grpc_status import rpc_status

sys.path.append("/code/app/grpc_compiled")
import hellostreamingworld_pb2
import hellostreamingworld_pb2_grpc

from google.protobuf.json_format import MessageToDict

from fastapi import FastAPI

_LOGGER = logging.getLogger(__name__)

app = FastAPI()


@app.get("/")
def read_root():
    print("Will try to greet world ...")
    return {"Hello": "World"}


@app.get("/greet/{user_name}")
async def greet_user(user_name: str):
    print("Will try to greet user async...")
    try:
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
    except grpc.RpcError as rpc_error:
        _LOGGER.error("Call failure: %s", rpc_error)
        status = rpc_status.from_call(rpc_error)
        for detail in status.details:
            if detail.Is(error_details_pb2.QuotaFailure.DESCRIPTOR):
                info = error_details_pb2.QuotaFailure()
                detail.Unpack(info)
                _LOGGER.error("Quota failure: %s", info)
                dict_obj = MessageToDict(info)
                res = dict_obj["violations"][0]
                return {"error": res["description"], "user_name": res["subject"].split(":")[1]}
            else:
                raise RuntimeError("Unexpected failure: %s" % detail)