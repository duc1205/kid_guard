"""Vẽ icon KidGuard: khiên trắng + mặt cười + huy hiệu đồng hồ cam, nền xanh gradient.

Xuất 3 file vào thư mục đích (argv[1]):
  app_icon.png             1024x1024, có nền, không trong suốt (iOS + Android cũ)
  app_icon_foreground.png  1024x1024, trong suốt, thu nhỏ vào vùng an toàn (Android adaptive)
  app_icon_background.png  1024x1024, chỉ nền gradient (Android adaptive)
"""
import math
import os
import sys

from PIL import Image, ImageDraw

OUT = sys.argv[1]
S = 4  # supersampling để viền mượt
N = 1024 * S

BLUE_TOP = (99, 126, 255)
BLUE_BOTTOM = (61, 79, 214)
NAVY = (30, 33, 64)
ORANGE = (255, 159, 67)
WHITE = (255, 255, 255)


def background() -> Image.Image:
    img = Image.new("RGB", (N, N))
    px = img.load()
    for y in range(N):
        for x in range(0, N):
            t = (x + y) / (2 * N)  # gradient chéo
            px[x, y] = tuple(int(a + (b - a) * t) for a, b in zip(BLUE_TOP, BLUE_BOTTOM))
    return img


def bezier(p0, p1, p2, p3, steps=80):
    pts = []
    for i in range(steps + 1):
        t = i / steps
        mt = 1 - t
        x = mt**3 * p0[0] + 3 * mt**2 * t * p1[0] + 3 * mt * t**2 * p2[0] + t**3 * p3[0]
        y = mt**3 * p0[1] + 3 * mt**2 * t * p1[1] + 3 * mt * t**2 * p2[1] + t**3 * p3[1]
        pts.append((x, y))
    return pts


def s(v):
    return v * S


CLEAR = (0, 0, 0, 0)


def draw_emblem(layer: Image.Image, mono: bool = False):
    """mono=True: bản đơn sắc cho themed icon Android 13 — chi tiết được khoét trong suốt."""
    navy = CLEAR if mono else NAVY
    orange = CLEAR if mono else ORANGE
    gap = CLEAR if mono else (74, 94, 226)
    d = ImageDraw.Draw(layer)
    # Khiên: đỉnh hơi nhô ở giữa, hai cạnh thẳng, đáy cong nhọn.
    top_l, top_c, top_r = (262, 250), (512, 196), (762, 250)
    pts = []
    pts += bezier(top_l, (360, 238), (440, 214), top_c, 40)
    pts += bezier(top_c, (584, 214), (664, 238), top_r, 40)[1:]
    pts += [(762, 520)]
    pts += bezier((762, 520), (762, 690), (650, 800), (512, 868), 60)[1:]
    pts += bezier((512, 868), (374, 800), (262, 690), (262, 520), 60)[1:]
    d.polygon([(s(x), s(y)) for x, y in pts], fill=WHITE)

    # Mặt cười
    for ex in (432, 592):
        r = 40
        d.ellipse([s(ex - r), s(460 - r), s(ex + r), s(460 + r)], fill=navy)
    cx, cy, r, w = 512, 520, 128, 36
    d.arc([s(cx - r), s(cy - r), s(cx + r), s(cy + r)], start=28, end=152, fill=navy, width=s(w))
    for ang in (28, 152):  # bo tròn hai đầu nụ cười
        ax = cx + r * math.cos(math.radians(ang)) - (w / 2) * math.cos(math.radians(ang))
        ay = cy + r * math.sin(math.radians(ang)) - (w / 2) * math.sin(math.radians(ang))
        d.ellipse([s(ax - w / 2), s(ay - w / 2), s(ax + w / 2), s(ay + w / 2)], fill=navy)

    # Huy hiệu đồng hồ
    bx, by, br = 712, 724, 140
    # Khe xanh (cùng tông nền tại vị trí này) tách huy hiệu khỏi khiên.
    d.ellipse([s(bx - br), s(by - br), s(bx + br), s(by + br)], fill=gap)
    br1 = br - 16
    d.ellipse([s(bx - br1), s(by - br1), s(bx + br1), s(by + br1)], fill=WHITE)
    br2 = br1 - 18
    d.ellipse([s(bx - br2), s(by - br2), s(bx + br2), s(by + br2)], fill=orange)
    hand = 20
    d.line([s(bx), s(by), s(bx), s(by - 66)], fill=WHITE, width=s(hand))
    d.line([s(bx), s(by), s(bx + 48), s(by + 22)], fill=WHITE, width=s(hand))
    for px_, py_ in ((bx, by - 66), (bx + 48, by + 22), (bx, by)):
        d.ellipse([s(px_ - hand / 2), s(py_ - hand / 2), s(px_ + hand / 2), s(py_ + hand / 2)], fill=WHITE)


def emblem_layer(scale=1.0, mono=False) -> Image.Image:
    layer = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    draw_emblem(layer, mono)
    # Căn giữa theo khối nhìn thấy (khiên + huy hiệu lệch phải-dưới).
    bbox = layer.getbbox()
    cx, cy = (bbox[0] + bbox[2]) / 2, (bbox[1] + bbox[3]) / 2
    if scale != 1.0:
        layer = layer.resize((int(N * scale), int(N * scale)), Image.LANCZOS)
        cx, cy = cx * scale, cy * scale
    out = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    out.paste(layer, (int(N / 2 - cx), int(N / 2 - cy)), layer)
    return out


def down(img):
    return img.resize((1024, 1024), Image.LANCZOS)


os.makedirs(OUT, exist_ok=True)
bg = background()

full = bg.convert("RGBA")
full.alpha_composite(emblem_layer(0.92))
down(full).convert("RGB").save(os.path.join(OUT, "app_icon.png"))

# flutter_launcher_icons tự thêm lề 16% mỗi cạnh → xuất ở cỡ lớn để vừa vùng an toàn (~61%).
down(emblem_layer(1.1)).save(os.path.join(OUT, "app_icon_foreground.png"))
down(emblem_layer(1.1, mono=True)).save(os.path.join(OUT, "app_icon_monochrome.png"))
down(bg).save(os.path.join(OUT, "app_icon_background.png"))
print("ok")

# macOS: ô vuông bo góc 824px trên nền trong suốt 1024px (theo lưới icon của Apple).
mac = Image.new("RGBA", (N, N), (0, 0, 0, 0))
body = full.resize((int(N * 824 / 1024),) * 2, Image.LANCZOS)
mask = Image.new("L", body.size, 0)
ImageDraw.Draw(mask).rounded_rectangle(
    [0, 0, body.size[0] - 1, body.size[1] - 1], radius=int(body.size[0] * 0.225), fill=255)
shadow = Image.new("RGBA", (N, N), (0, 0, 0, 0))
sh_mask = Image.new("L", body.size, 0)
ImageDraw.Draw(sh_mask).rounded_rectangle(
    [0, 0, body.size[0] - 1, body.size[1] - 1], radius=int(body.size[0] * 0.225), fill=70)
off = (N - body.size[0]) // 2
shadow.paste((0, 0, 0, 255), (off, off + 10 * S), sh_mask)
from PIL import ImageFilter
shadow = shadow.filter(ImageFilter.GaussianBlur(12 * S))
mac.alpha_composite(shadow)
mac.paste(body, (off, off), mask)
down(mac).save(os.path.join(OUT, "app_icon_macos.png"))
