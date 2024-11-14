#!/usr/bin/env python3

# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "ipython<9",
#     "numpy<3",
#     "pandas<3",
#     "tqdm<5",
#     "matplotlib<4",
#     "seaborn<1",
#     "scipy<2",
# ]
# [tool.uv]
# exclude-newer = "2024-11-01T00:00:00Z"
# ///

import os, sys, math, pickle, json, time, random, re, copy, shutil, subprocess, datetime, collections, itertools, functools, dataclasses

def lazy_import(name):
    import importlib.util
    spec = importlib.util.find_spec(name)
    loader = importlib.util.LazyLoader(spec.loader)
    spec.loader = loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    loader.exec_module(module)
    return module

tqdm = lazy_import("tqdm")
np = lazy_import("numpy")
pd = lazy_import("pandas")
scipy = lazy_import("scipy")
matplotlib = lazy_import("matplotlib")
plt = lazy_import("matplotlib.pyplot")
sns = lazy_import("seaborn")

from IPython import embed as _embed
_embed(colors="neutral", confirm_exit=False, display_banner=False)
