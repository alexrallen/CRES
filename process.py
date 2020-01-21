#!/usr/bin/env python

from rootpy.tree import Tree
from rootpy.io import root_open

f = root_open('./output/TrappingFieldTerms.root')

track = f.get('component_track_world_DATA')
step = f.get('component_step_world_DATA')
step_map = f.get('TRACK_DATA')

step_map.csv(stream=open('trap_map.csv', 'w'))
track.csv(stream=open('trap_track.csv', 'w'))
step.csv(stream=open('trap_step.csv', 'w'))


