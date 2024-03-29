# ===========================================================
# 1d normalized surface for ResNet-56
# ===========================================================

mpirun -n 4 python script_plot_surface.py --x="-1:1:51" --model "resnet56" \
--model_file "./trained_nets/cifar10/resnet56/resnet56_sgd_lr=0.1_bs=128_wd=0.0005/model_300.t7" \
--cuda --mpi --dir_type "states" --xnorm "filter" --xignore "biasbn"

# mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model resnet56 \
# --model_file ./trained_nets/cifar10/resnet56/resnet56_sgd_lr=0.1_bs=128_wd=0.0_save_epoch=1/model_300.t7 \
# --cuda --mpi --dir_type states --xnorm filter --xignore biasbn

# mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model resnet56 \
# --model_file ./trained_nets/cifar10/resnet56/resnet56_sgd_lr=0.1_bs=4096_wd=0.0_save_epoch=1/model_300.t7 \
# --cuda --mpi --dir_type states --xnorm filter --xignore biasbn

# mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model resnet56 \
# --model_file ./trained_nets/cifar10/resnet56/resnet56_sgd_lr=0.1_bs=128_wd=0.0005_save_epoch=1/model_300.t7 \
# --cuda --mpi --dir_type states --xnorm filter --xignore biasbn

# mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model resnet56 \
# --model_file ./trained_nets/cifar10/resnet56/resnet56_sgd_lr=0.1_bs=4096_wd=0.0005_save_epoch=1/model_300.t7 \
# --cuda --mpi --dir_type states --xnorm filter --xignore biasbn

# mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model resnet56 \
# --model_file ./trained_nets/cifar10/resnet56/resnet56_adam_lr=0.001_bs=128_wd=0.0_save_epoch=1/model_300.t7 \
# --cuda --mpi --dir_type states --xnorm filter --xignore biasbn

# mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model resnet56 \
# --model_file ./trained_nets/cifar10/resnet56/resnet56_adam_lr=0.001_bs=4096_wd=0.0_save_epoch=1/model_300.t7 \
# --cuda --mpi --dir_type states --xnorm filter --xignore biasbn

# mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model resnet56 \
# --model_file ./trained_nets/cifar10/resnet56/resnet56_adam_lr=0.001_bs=128_wd=0.0005_save_epoch=1/model_300.t7 \
# --cuda --mpi --dir_type states --xnorm filter --xignore biasbn

# mpirun -n 4 python script_plot_surface.py --x=-1:1:51 --model resnet56 \
# --model_file ./trained_nets/cifar10/resnet56/resnet56_adam_lr=0.001_bs=4096_wd=0.0005_save_epoch=1/model_300.t7 \
# --cuda --mpi --dir_type states --xnorm filter --xignore biasbn
