python -m pip install --upgrade pip

sudo apt install ffmpeg colmap yq

pip install torch==2.1.2+cu118 torchvision==0.16.2+cu118 --extra-index-url https://download.pytorch.org/whl/cu118

conda install -c "nvidia/label/cuda-11.8.0" cuda-toolkit

pip install ninja git+https://github.com/NVlabs/tiny-cuda-nn/#subdirectory=bindings/torch

git clone https://github.com/mackopes/nerfstudio.git
cd nerfstudio
pip install --upgrade pip setuptools
pip install -e .

cd ..

export MAX_JOBS=2
export TORCH_CUDA_ARCH_LIST="7.5"
pip install git+https://github.com/nerfstudio-project/gsplat.git@v1.4.0

git clone --recursive https://github.com/cvg/Hierarchical-Localization/
cd Hierarchical-Localization/
python -m pip install -e .

cd ..

pip install pycolmap==3.11.1
