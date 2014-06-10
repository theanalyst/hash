try:
    from functools import singledispatch
except ImportError:
    from singledispatch import singledispatch  # NOQA
