from PIL import Image
import numpy as np

# im = Image.open("p2.jpg")
# data = np.asarray(im, dtype=np.uint8)
# np.savetxt("rgb_data3.txt", data.ravel(), fmt='%i')


# ls = ["score1", "turn", "aiprompt", "invalid"]

ls = ["player1", "player2", "player3"]
for p in ls :
	im = Image.open(p + ".png")
	data = np.asarray(im, dtype=np.uint8)
	np.savetxt(p + ".txt", data.ravel(), fmt='%i')
