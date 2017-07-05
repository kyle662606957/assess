import io
import matplotlib.pyplot as plt
import base64


def render(formula, fontsize=4, dpi=300, format_='png'):
    """Renders LaTeX formula into image.
    """
    fig = plt.figure(figsize=(0.01, 0.01))
    fig.text(0, 0, u'${}$'.format(formula), fontsize=fontsize)
    imgdata = io.BytesIO()
    fig.savefig(imgdata, dpi=dpi, transparent=True, format=format_,
                bbox_inches='tight', pad_inches=0.0)
    plt.close(fig)
    imgdata = base64.b64encode(imgdata.getvalue())
    return imgdata
