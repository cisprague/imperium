#!/usr/bin/env bash

mkdir tmp
cd tmp
git clone https://github.com/esa/pagmo2.git &
git clone https://github.com/coin-or/Ipopt.git &
wait
