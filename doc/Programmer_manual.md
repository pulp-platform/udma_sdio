# Programmer manual (registers are in SDIO_reference.xlsx, commands and exact protocol are in the SDIO physical layer manual)

## Sending a command
### To send a command use cmd_op and cmd arg registers, cmd_op contains both the command (bits [16:8] and expected answer type bits [7:0])
### To wait on the end of the command, one must wait for EOT soc event
### When EOT arrives, STATUS must be checked to verify if the command terminated normally or if a timeout/error happened

## Responses
### All reponses execpt CID (CMD2) are 32 bits wide (32 data + 16 CRC), CID is 128bits
### CRC is checked by uDMA, as such only the 32/128 bits of data are mapped on the RSP0 register (instead of 48/136)

## Initialization procedure
### First send CMD0
### Next Send CMD8 to negociate voltage with the sdcard
#### If no answer, use default voltage
#### else check if voltage is compatible (if not, sd card is not usable)
### Send CMD55 followed by ACMD41: arg 0 if want to support only standard capacity card, 1 for high capacity
#### Send in a loop until card does not return "Busy" anymore
### Send CMD2 (SD card send CID), wait for answer, which need to happen but value can be safely ignored
### Send CMD3 (SD card send RCA). Retrieve RCA (card identifier) from bit [31:16] of response and store it

## Reading a single block of data from the card (card must be initialized first)
### Send card selection and configuration procedure first 
#### First send CMD7 with previously obtained RCA as an argument (shifted back to [31:16] position)
#### Next send CMD55 + ACMD6 to choose bus width: arg=0 means 1 data line arg=2 means quad mode (4 data lines)
### Setup SDIO udma channels RX channel with rx buffer address and buffer size (size must be a multiple of sd card block size)
### Configure SDIO DATA_SETUP register: 
#### Set bit RWN to 1, quad to the previously chosen config, BLOCK_NUM to 0 (nb of blocks -1) , DATA_EN to 1, and BLOCK_SIZE to 511 (512-1).
### Then send CMD17 to the card, with the address of an sd card block as the argument
### Finaly, wait for EOT before attempting any other commands

## Write a single block of data: Same as read except for three items:
### First RWN need to be set to '0'
### Second, the udma TX channel need to be set instead (TX_SIZE+TX_BUFFER)
### Finally, the CMD which must be sent is CMD24

## To send mutliple blocks, replace CMD17 with CMD18 and CMD24 with CMD25

## NOTE1: do not send CMD12 (stop transfer) as this is done by the udma automatically
## NOTE2: Transfer size must always be a multiple of block size
## NOTE3: Block NUM is always the number of blocks to be transfered -1
## NOTE4: Always clear DATA_SETUP after a transfer is finished(read or write)
