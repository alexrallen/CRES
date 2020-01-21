#!/usr/bin/env python

from rootpy.tree import Tree
from rootpy.io import root_open

f = root_open('./output/ConstantEBFieldTerms.root')

track = f.get('component_track_world_DATA')
step = f.get('component_step_world_DATA')
step_map = f.get('TRACK_DATA')

step_map.csv(stream=open('map_efield.csv', 'w'))
track.csv(stream=open('track_efield.csv', 'w'))
step.csv(stream=open('step_efield.csv', 'w'))


