#!/bin/bash
[ "$(git -C ~/tutorial log --oneline | wc -l)" -ge 4 ]