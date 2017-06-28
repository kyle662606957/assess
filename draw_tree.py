from PIL import Image, ImageDraw, ImageFont
import io


def scale(image, offset_x, offset_y, type="gain", method=Image.ANTIALIAS):
    width, height = image.size
    offset = (offset_x, offset_y)
    back = Image.new(
        "RGBA", (width + offset_x, height + offset_y), (255, 0, 0, 0))
    back.paste(image, offset)
    return back


def max_text_width(text):
    font = ImageFont.truetype("HelveticaNeue.ttf", 14)
    max_width = 0
    lines = text.split("\n")
    for i in range(len(lines)):
        width = font.getsize(lines[i])[0]
        if width > max_width:
            max_width = width
    return max_width


def text_height(text):
    font = ImageFont.truetype("HelveticaNeue.ttf", 14)
    height = 0
    lines = text.split("\n")
    for i in range(len(lines)):
        height += font.getsize(lines[i])[1]
    return height


def draw(text="Test\nTest Test\nTest Test Test", type="gain"):
    imgdata = io.BytesIO()
    tree = Image.open('static/img/tree_choice.png').convert('RGBA')
    font = ImageFont.truetype("HelveticaNeue.ttf", 14)
    text_x = max_text_width(text)
    text_y = text_height(text)
    tree = scale(tree, text_x, 0)
    draw = ImageDraw.Draw(tree)
    width, height = tree.size
    x = 0
    y = int(height / 2) - int(text_y / 2)
    draw.text((x, y), text, font=font, fill="black")
    tree.save(imgdata, format="png")


draw()
