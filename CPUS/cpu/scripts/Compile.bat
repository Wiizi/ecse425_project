@echo off		
		
pushd "%~dp0\..\quartus"		
C:\altera\13.0sp1\modelsim_ase\win32aloem\vsim.exe -c -do "set topLevelDir \"[pwd]/..\"; source ../scripts/livecpulib.tcl; CompileCPU; quit"		
popd		
		
		
:EXIT		