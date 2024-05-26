#!/bin/env bash
tar -zcvf banddos.tar.gz --exclude WAVECAR --exclude CHG --exclude CHGCAR --exclude AECCAR0 --exclude AECCAR1 --exclude AECCAR2 --exclude vasprun.xml --exclude POT --exclude LOCPOT band dos
