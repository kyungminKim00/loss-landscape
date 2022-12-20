python script_h52vtp.py --surf_file="./trained_nets/cifar10/vgg9/vgg9_sgd_lr=0.1_bs=128_wd=0.0005_save_epoch=1/model_300.t7_weights_xignore=biasbn_xnorm=filter_yignore=biasbn_ynorm=filter.h5_[-1.0,1.0,51]x[-1.0,1.0,51].h5" --surf_name="train_loss" --zmax=10 --log

python script_h52vtp.py --surf_file="./trained_nets/cifar10/resnet56_noshort/resnet56_noshort_sgd_lr=0.1_bs=128_wd=0.0005/model_300.t7_weights_xignore=biasbn_xnorm=filter_yignore=biasbn_ynorm=filter.h5_[-1.0,1.0,201]x[-1.0,1.0,201].h5" --surf_name="train_loss" --zmax=10 --log

