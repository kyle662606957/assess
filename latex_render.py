from cStringIO import StringIO

import matplotlib.pyplot as plt


def render(formula, name, fontsize=4, dpi=300, format_='png'):
    """Renders LaTeX formula into image.
    """
    fig = plt.figure(figsize=(0.01, 0.01))
    fig.text(0, 0, u'${}$'.format(formula), fontsize=fontsize)
    buffer_ = StringIO()
    fig.savefig(buffer_, dpi=dpi, transparent=True, format=format_,
                bbox_inches='tight', pad_inches=0.0)
    plt.close(fig)
    img = buffer_.getvalue()
    with open('equations/'+name, 'wb') as image_file:
        image_file.write(img)
