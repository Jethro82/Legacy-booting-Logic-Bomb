DECLARE SUB WriteSector(index%, filename$)
TYPE Sector
        MachineCode AS STRING * 510
        signature AS INTEGER
END TYPE
DIM SHARED Sector AS Sector
Sector.signature = &HAA55 ;add boot signature to end of sector
OPEN "floppy.img" FOR RANDOM AS #1 LEN = 512
WriteSector 1, "floppybs"
WriteSector 2, "datechck"
WriteSector 4, "payload"
Sector.MachineCode = ""
PUT #1, 2880, Sector ;set size of file to exactly 1440KiB
Close #1

SUB WriteSector (SecNo%, filename$)
	OPEN filename$ + ".COM" FOR RANDOM AS #2 LEN = 510
	GET #2, 1, Sector.MachineCode
	PUT #1, SecNo%, Sector
	CLOSE #2
END SUB

