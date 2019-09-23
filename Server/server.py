import websockets
import asyncio
from PIL import Image
import pickle

# This server is only a proof of concept. It currently just saves one color channel of the first image it receives to a file
# Use the Show Image jupyter notebook to see the image

alreadyRun = False


def saveImg(bytes):
    global alreadyRun
    if alreadyRun:
        return
    alreadyRun = True
    pickle.dump(bytes, open("out.pkl","wb"))
    print("Saved img")
    



async def waitformessage(websocket, path):
    async for message in websocket:
        saveImg(message)

start_server = websockets.serve(waitformessage,"192.168.178.53",8585)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()


from PIL import Image
