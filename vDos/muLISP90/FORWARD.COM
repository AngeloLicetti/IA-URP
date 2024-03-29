��Serial to Parallel Printing Utility (1 July 1991)
Copyright (C) 1991 Soft Warehouse, Inc.
Honolulu, Hawaii, 96816, USA
OEM licenses available.  Type FORWARD/H for help.

$The FORWARD utility forwards data from a serial port to a parallel port.

Command line syntax:	FORWARD  COMm:b  LPTn

The serial port number m is a digit between 1 and 4.
The serial baud rate b is 110, 150, 300, 600, 1200, 2400, 4800, or 9600.
The parallel port number n is a digit between 1 and 3.
The default serial and parallel port number is 1.
The default baud rate is the current baud rate.

Command line example:	FORWARD  COM1:9600  LPT1
$Insufficient memory, aborting
$Forwarding characters (press Esc key to abort) ...$    �Ȏм �؎������ � �C��s\<Lt[<CuK�O��sD�M��s=�s8�s3� ����s2<Lt1<:u��s%<Lt$<1t+<2ta<3tv<4t<6t<9t������ �� �k� � �s�<1t<2t<5uذ0�sѰ � �0�~sŰ ��0�ss��0�ls����m�4�as��0�Zs��0�Ss����T�0�Hs��0�As��@�B�8�6s�0�/s�0�(s���)�0�sڰ0�sӰ`��6�sȰ0�s��0�� s���
�PSQRVW��� �_^ZY[X�� s)<Lu��P�� s��T�� s��� s��� s�� ��� s����� ���  �   ; v
�y� �����u �% s���j � �L�!� �& ;�t��A u�&�F�K �ش��VW�!_^t<u���ù ���QVW�_^Y��u��ú��&�Gô��VW�_^���āô ��	�!��! s�� t���< t<	�P��� s:�Xu��X��	I�� C����<ar�<zw, �<1r�<9w�,1��