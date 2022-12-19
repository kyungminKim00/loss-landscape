# =============================================================================
# 1d linear interpolation for VGG-9
# =============================================================================
mpirun -n 3 python plot_surface.py --x=-0.5:1.5:401 --model vgg9 --dir_type states --mpi --cuda \
--model_file ./trained_nets/cifar10/vgg9/vgg9_sgd_lr=0.1_bs=128_wd=0.0_save_epoch=1/model_300.t7 \
--model_file2 ./trained_nets/cifar10/vgg9/vgg9_sgd_lr=0.1_bs=8192_wd=0.0_save_epoch=1/model_300.t7 --plot

mpirun -n 3 python plot_surface.py --x=-0.5:1.5:401 --model vgg9 --dir_type states --mpi --cuda \
--model_file ./trained_nets/cifar10/vgg9/vgg9_sgd_lr=0.1_bs=128_wd=0.0005_save_epoch=1/model_300.t7 \
--model_file2 ./trained_nets/cifar10/vgg9/vgg9_sgd_lr=0.1_bs=8192_wd=0.0005_save_epoch=1/model_300.t7 --plot

mpirun -n 3 python plot_surface.py --x=-0.5:1.5:401 --model vgg9 --dir_type states --mpi --cuda \
--model_file ./trained_nets/cifar10/vgg9/vgg9_adam_lr=0.001_bs=128_wd=0.0_save_epoch=1/model_300.t7 \
--model_file2 ./trained_nets/cifar10/vgg9/vgg9_adam_lr=0.001_bs=8192_wd=0.0_save_epoch=1/model_300.t7 --plot

mpirun -n 3 python plot_surface.py --x=-0.5:1.5:401 --model vgg9 --dir_type states --mpi --cuda \
--model_file ./trained_nets/cifar10/vgg9/vgg9_adam_lr=0.001_bs=128_wd=0.0005_save_epoch=1/model_300.t7 \
--model_file2 ./trained_nets/cifar10/vgg9/vgg9_adam_lr=0.001_bs=8192_wd=0.0005_save_epoch=1/model_300.t7 --plot