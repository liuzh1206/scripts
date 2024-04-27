#!/bin/env bash
tar -zcvf E.tar.gz E --exclude WAVECAR --exclude CHG --exclude CHGCAR --exclude AECCAR0 --exclude AECCAR1 --exclude AECCAR2 --exclude vaspout.h5 --exclude vasprun.xml --exclude POT --exclude LOCPOT
