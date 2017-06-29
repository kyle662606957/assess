from PIL import Image, ImageDraw, ImageFont
import io
import base64


def scale(image, text_x_gain, text_y_gain, text_x_upper_label, text_y_upper_label, text_x_bottom_label, text_y_bottom_label, text_x_upper_proba, text_y_upper_proba, text_x_bottom_proba, text_y_bottom_proba, method=Image.ANTIALIAS):
    width, height = image.size
    offsetx = offset_x(text_x_gain, text_x_upper_label, text_x_bottom_label)
    offsety = offset_y(text_y_upper_label, text_y_bottom_label)
    back = Image.new(
        "RGBA", (width + offsetx, height + offsety), (255, 255, 255, 0))
    back.paste(image, (text_x_gain + 10, int(text_y_upper_label) / 2 + 10))
    return back


def max_text_width(text):
    font = ImageFont.truetype("static/fonts/HelveticaNeue.ttf", 16, encoding="utf-8")
    max_width = 0
    lines = text.split("\n")
    for i in range(len(lines)):
        width = font.getsize(lines[i])[0]
        if width > max_width:
            max_width = width
    return max_width


def text_height(text):
    font = ImageFont.truetype("static/fonts/HelveticaNeue.ttf", 16, encoding="utf-8")
    height = 0
    lines = text.split("\n")
    for i in range(len(lines)):
        height += font.getsize(lines[i])[1]
    height += 7 * (len(lines) - 1)
    return height


def offset_x(text_x_gain, text_x_upper_label, text_x_bottom_label):
    offset = text_x_gain + 20
    if text_x_upper_label > text_x_bottom_label:
        offset += text_x_upper_label
    else:
        offset += text_x_bottom_label
    return offset


def offset_y(text_y_upper_label, text_y_bottom_label):
    offset = int(text_y_upper_label / 2) + int(text_y_bottom_label / 2) + 20
    return offset


def draw(gain, upper_label, bottom_label, upper_proba, bottom_proba):
    gain = str(gain.encode('utf-8'))
    upper_label = str(upper_label.encode('utf-8'))
    bottom_label = str(bottom_label.encode('utf-8'))
    upper_proba = str(upper_proba)
    bottom_proba = str(bottom_proba)
    imgdata = io.BytesIO()
    tree = Image.open('static/img/tree_choice.png').convert('RGBA')
    font = ImageFont.truetype("static/fonts/HelveticaNeue.ttf", 16, encoding="utf-8")
    text_x_gain = max_text_width(gain)
    text_y_gain = text_height(gain)
    text_x_upper_label = max_text_width(upper_label)
    text_y_upper_label = text_height(upper_label)
    text_x_bottom_label = max_text_width(bottom_label)
    text_y_bottom_label = text_height(bottom_label)
    text_x_upper_proba = font.getsize(upper_proba)[0]
    text_y_upper_proba = font.getsize(upper_proba)[1]
    text_x_bottom_proba = font.getsize(bottom_proba)[0]
    text_y_bottom_proba = font.getsize(bottom_proba)[1]
    width, height = tree.size
    draw = ImageDraw.Draw(tree)
    x = 190
    y = 15
    draw.text((x, y), upper_proba, font=font, fill=(0,0,0,255))
    x = 190
    y = height - text_y_bottom_proba - 15
    draw.text((x, y), bottom_proba, font=font, fill=(0,0,0,255))
    tree = scale(tree, text_x_gain, text_y_gain, text_x_upper_label, text_y_upper_label, text_x_bottom_label,
                 text_y_bottom_label, text_x_upper_proba, text_y_upper_proba, text_x_bottom_proba, text_y_bottom_proba)
    draw = ImageDraw.Draw(tree)
    offsetx = offset_x(text_x_gain, text_x_upper_label, text_x_bottom_label)
    offsety = offset_y(text_y_upper_label, text_y_bottom_label)
    x = 5
    y = int((height + offsety - text_y_gain) / 2)
    draw.text((x, y), gain.decode("utf-8"), font=font, fill=(0,0,0,255))
    x = width + offsetx - text_x_upper_label - 10
    y = 10
    draw.text((x, y), upper_label.decode("utf-8"), font=font, fill=(0,0,0,255))
    x = width + offsetx - text_x_bottom_label - 10
    y = height + offsety - text_y_bottom_label - 10
    draw.text((x, y), bottom_label.decode("utf-8"), font=font, fill=(0,0,0,255))
    tree.save(imgdata, format="png")
    imgdata = base64.b64encode(imgdata.getvalue())
    return imgdata
