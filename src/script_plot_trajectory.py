"""
    Plot the optimization path in the space spanned by principle directions.
"""

import argparse
import copy
import math
import os

import h5py
import numpy as np
import torch

import model_loader
import net_plotter
import plot_2D
from projection import project_trajectory, setup_PCA_directions

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Plot optimization trajectory')
    parser.add_argument('--dataset', default='cifar10', help='dataset')
    parser.add_argument('--model', default='vgg9', help='trained models')
    parser.add_argument('--model_folder', default='./trained_nets/cifar10/vgg9/vgg9_sgd_lr=0.1_bs=128_wd=0.0005_save_epoch=1', help='folders for models to be projected')
    parser.add_argument('--dir_type', default='weights',
        help="""direction type: weights (all weights except bias and BN paras) |
                                states (include BN.running_mean/var)""")
    parser.add_argument('--ignore', default='biasbn', help='ignore bias and BN paras: biasbn (no bias or bn)')
    parser.add_argument('--prefix', default='model_', help='prefix for the checkpint model')
    parser.add_argument('--suffix', default='.t7', help='prefix for the checkpint model')
    parser.add_argument('--start_epoch', default=300, type=int, help='min index of epochs')
    parser.add_argument('--max_epoch', default=300, type=int, help='max number of epochs')
    parser.add_argument('--save_epoch', default=1, type=int, help='save models every few epochs')
    parser.add_argument('--dir_file', default='', help='load the direction file for projection')

    args = parser.parse_args()

    #--------------------------------------------------------------------------
    # load the final model
    #--------------------------------------------------------------------------
    last_model_file = args.model_folder + '/' + args.prefix + str(args.max_epoch) + args.suffix
    net = model_loader.load(args.dataset, args.model, last_model_file)
    w = net_plotter.get_weights(net)
    s = net.state_dict()

    #--------------------------------------------------------------------------
    # collect models to be projected
    #--------------------------------------------------------------------------
    model_files = []
    for epoch in range(args.start_epoch, args.max_epoch + args.save_epoch, args.save_epoch):
        model_file = args.model_folder + '/' + args.prefix + str(epoch) + args.suffix
        assert os.path.exists(model_file), 'model %s does not exist' % model_file
        model_files.append(model_file)

    #--------------------------------------------------------------------------
    # load or create projection directions
    #--------------------------------------------------------------------------
    if args.dir_file:
        dir_file = args.dir_file
    else:
        dir_file = setup_PCA_directions(args, model_files, w, s)

    #--------------------------------------------------------------------------
    # projection trajectory to given directions
    #--------------------------------------------------------------------------
    proj_file = project_trajectory(dir_file, w, s, args.dataset, args.model,
                                model_files, args.dir_type, 'cos')
    plot_2D.plot_trajectory(proj_file, dir_file)
