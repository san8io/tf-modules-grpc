# Copyright 2021 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""The Python AsyncIO implementation of the GRPC hellostreamingworld.MultiGreeter server."""

from concurrent import futures
import asyncio
import logging
import sys
import threading

from google.protobuf import any_pb2
from google.rpc import code_pb2
from google.rpc import error_details_pb2
from google.rpc import status_pb2
import grpc
from grpc_status import rpc_status

sys.path.append("/code/app/grpc_compiled")
from hellostreamingworld_pb2 import HelloReply
from hellostreamingworld_pb2 import HelloRequest
from hellostreamingworld_pb2_grpc import MultiGreeterServicer
from hellostreamingworld_pb2_grpc import add_MultiGreeterServicer_to_server

NUMBER_OF_REPLY = 10

def create_greet_limit_exceed_error_status(name):
    detail = any_pb2.Any()
    detail.Pack(
        error_details_pb2.QuotaFailure(
            violations=[
                error_details_pb2.QuotaFailure.Violation(
                    subject="name: %s" % name,
                    description="Limit one greeting per person",
                )
            ],
        )
    )
    return status_pb2.Status(
        code=code_pb2.RESOURCE_EXHAUSTED,
        message="Request limit exceeded.",
        details=[detail],
    )


class Greeter(MultiGreeterServicer):
    def __init__(self):
        self._lock = threading.RLock()
        self._greeted = set()

    async def sayHello(
        self, request: HelloRequest, context: grpc.aio.ServicerContext
    ) -> HelloReply:
        logging.info("Serving sayHello request %s", request)
        with self._lock:
            if request.name in self._greeted:
                rich_status = create_greet_limit_exceed_error_status(
                    request.name
                )
                await context.abort_with_status(rpc_status.to_status(rich_status))
            else:
                self._greeted.add(request.name)

            for i in range(NUMBER_OF_REPLY):
                yield HelloReply(message=f"Hello number {i}, {request.name}!")


async def serve() -> None:
    server = grpc.aio.server()
    add_MultiGreeterServicer_to_server(Greeter(), server)
    listen_addr = "[::]:50051"
    server.add_insecure_port(listen_addr)
    logging.info("Starting server on %s", listen_addr)
    await server.start()
    await server.wait_for_termination()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    asyncio.run(serve())
