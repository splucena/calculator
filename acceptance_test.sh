#!/bin/bash
test $(curl http://172.17.0.5:8765/sum?a=1\&b=2) -eq 3``