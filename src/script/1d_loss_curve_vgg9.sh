# ===========================================================
# 1d normalized surface for VGG-9
# ===========================================================

mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model vgg9 \
--model_file "./trained_nets/cifar10/vgg9/vgg9_sgd_lr=0.1_bs=128_wd=0.0_save_epoch=1/model_300.t7" \
--mpi --cuda --dir_type "weights" --xnorm "filter" --xignore ""biasbn"" --plot

mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model vgg9 \
--model_file "./trained_nets/cifar10/vgg9/vgg9_sgd_lr=0.1_bs=8192_wd=0.0_save_epoch=1/model_300.t7" \
--mpi --cuda --dir_type "weights" --xnorm "filter" --xignore "biasbn" --plot

mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model vgg9 \
--model_file "./trained_nets/cifar10/vgg9/vgg9_sgd_lr=0.1_bs=128_wd=0.0005_save_epoch=1/model_300.t7" \
--mpi --cuda --dir_type "weights" --xnorm "filter" --xignore "biasbn" --plot

mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model vgg9 \
--model_file "./trained_nets/cifar10/vgg9/vgg9_sgd_lr=0.1_bs=8192_wd=0.0005_save_epoch=1/model_300.t7" \
--mpi --cuda --dir_type "weights" --xnorm "filter" --xignore "biasbn" --plot

mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model vgg9 \
--model_file "./trained_nets/cifar10/vgg9/vgg9_adam_lr=0.001_bs=128_wd=0.0_save_epoch=1/model_300.t7" \
--mpi --cuda --dir_type "weights" --xnorm "filter" --xignore "biasbn" --plot

mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model vgg9 \
--model_file "./trained_nets/cifar10/vgg9/vgg9_adam_lr=0.001_bs=8192_wd=0.0_save_epoch=1/model_300.t7" \
--mpi --cuda --dir_type "weights" --xnorm "filter" --xignore "biasbn" --plot

mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model vgg9 \
--model_file "./trained_nets/cifar10/vgg9/vgg9_adam_lr=0.001_bs=128_wd=0.0005_save_epoch=1/model_300.t7" \
--mpi --cuda --dir_type "weights" --xnorm "filter" --xignore "biasbn" --plot

mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model vgg9 \
--model_file "./trained_nets/cifar10/vgg9/vgg9_adam_lr=0.001_bs=8192_wd=0.0005_save_epoch=1/model_300.t7" \
--mpi --cuda --dir_type "weights" --xnorm "filter" --xignore "biasbn" --plot