#!/bin/bash

apt-get update && apt-get install -y libopencv-dev \
                                    libsndfile1-dev \
                                    portaudio19-dev

export SRC_DIR=/opt/src
export BUILD_DIR=$SRC_DIR/build-vision
export INSTALL_DIR=$SRC_DIR/install-vision
export BUILD_SPEECH_DIR=$SRC_DIR/build-speech
export INSTALL_SPEECH_DIR=$SRC_DIR/install-speech
export LD_LIBRARY_PATH=$SRC_DIR/vision-lib/lib
export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libopencv_core.so.2.4
mkdir -p $SRC_DIR $BUILD_DIR $INSTALL_DIR $BUILD_SPEECH_DIR $INSTALL_SPEECH_DIR

echo "######################### Building Vision SDK #########################"
cd $BUILD_DIR
cmake -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR -DOpenCV_DIR=/usr/ -DBOOST_ROOT=$SRC_DIR/boost_1_63_0 -DAFFECTIVA_SDK_DIR=$SRC_DIR/vision-lib $SRC_DIR/sdk-samples/vision

make -j${nproc}
make install

echo "######################### Building Speech SDK #########################"
cd $BUILD_SPEECH_DIR
cmake -DCMAKE_INSTALL_PREFIX=$BUILD_SPEECH_DIR -DCMAKE_BUILD_TYPE=Release \
-DBOOST_ROOT=$SRC_DIR/boost_1_63_0 -DAFFECTIVA_SDK_DIR=$SRC_DIR/speech-lib \
-DBUILD_MIC=ON -DPortAudio_INCLUDE=/usr/include -DPortAudio_LIBRARY=/usr/lib/aarch64-linux-gnu/libportaudio.so.2 \
-DBUILD_WAV=ON -DLibSndFile_INCLUDE=/usr/include -DLibSndFile_LIBRARY=/usr/lib/aarch64-linux-gnu/libsndfile.so \
-DCMAKE_CXX_FLAGS="-pthread" $SRC_DIR/sdk-samples/speech

make -j${nproc}
