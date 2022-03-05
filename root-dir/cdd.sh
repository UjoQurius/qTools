#!/bin/bash

if [ $# -eq 0 ]
then
        cd $(cat ~/.cdd)
        /usr/bin/zsh
        exit
fi

if [ $1 = "." ]
then
        pwd > ~/.cdd
fi