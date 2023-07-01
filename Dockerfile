FROM debian:latest

ENV TERM screen-256color

RUN apt-get update && apt-get install apt-transport-https ca-certificates -y

COPY sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install python3 zsh ninja-build git tmux make -y

RUN cd && git clone https://github.com/gpakosz/.tmux.git && ln -s -f .tmux/.tmux.conf && cp .tmux/.tmux.conf.local .

ENV EDITOR "vim"

RUN apt-get install lsb-release wget software-properties-common gnupg -y

RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

RUN git clone https://github.com/vim/vim.git && cd vim/src && CC=clang-15 CXX=clang++-15 ./configure --with-features=huge --enable-python3interp \
    && make && make install

COPY .vimrc /root/

RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

RUN bash -c 'vim +PluginInstall +qall <<< "\n"'

RUN apt-get install cmake python3-dev -y

RUN cd /root/.vim/bundle/YouCompleteMe && EXTRA_CMAKE_ARGS='-DCMAKE_CXX_COMPILER=clang++-15 -DCMAKE_C_COMPILER=clang-15' ./install.py --ninja --clangd-completer --force-sudo


RUN wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | gpg --dearmor | tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null

RUN echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" |  tee /etc/apt/sources.list.d/oneAPI.list

RUN apt-get update && apt-get install git-lfs linux-perf libnuma-dev libcurl4-openssl-dev libtbb-dev curl -y

RUN git lfs install --system

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ENTRYPOINT zsh
