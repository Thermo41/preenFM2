PFM2_VERSION_NUMBER=2.11
PFM2_VERSION:=\"${PFM2_VERSION_NUMBER}\"

ifeq ($(MAKECMDGOALS),pfm)
BUILD_PREFIX:=build/p2_${PFM2_VERSION_NUMBER}
endif
ifeq ($(MAKECMDGOALS),pfmo)
BUILD_PREFIX:=build/p2_${PFM2_VERSION_NUMBER}o
endif
ifeq ($(MAKECMDGOALS),pfmcv)
BUILD_PREFIX:=build/p2_cv_${PFM2_VERSION_NUMBER}
endif
ifeq ($(MAKECMDGOALS),pfmcvo)
BUILD_PREFIX:=build/p2_cv_${PFM2_VERSION_NUMBER}o
endif

ELF_FIRMWARE:=${BUILD_PREFIX}.elf
BIN_FIRMWARE:=${BUILD_PREFIX}.bin
SYMBOLS_FIRMWARE:=${BUILD_PREFIX}_symbol.txt
PFM2_BOOTLOADER_VERSION_NUMBER:=1.11
PFM2_BOOTLOADER_VERSION:=\"${PFM2_BOOTLOADER_VERSION_NUMBER}\"
ELF_BOOTLOADER:=build/${PFM2_PREFIX}_boot_${PFM2_BOOTLOADER_VERSION_NUMBER}.elf
BIN_BOOTLOADER:=build/${PFM2_PREFIX}_boot_${PFM2_BOOTLOADER_VERSION_NUMBER}.bin
SYMBOLS_BOOTLOADER:=build/symbols_${PFM2_PREFIX}_boot_${PFM2_BOOTLOADER_VERSION_NUMBER}.txt


C      = arm-none-eabi-gcc
CC      = arm-none-eabi-c++
LD      = arm-none-eabi-ld -v
CP      = arm-none-eabi-objcopy
OD      = arm-none-eabi-objdump
AS      = arm-none-eabi-as


SRC_FIRMWARE:=src/PreenFM.cpp \
	src/PreenFM_irq.c \
	src/PreenFM_init.c \
	src/usb/usbKey_usr.c \
	src/usb/usbMidi_usr.c \
	src/usb/usbd_midi_desc.c \
	src/usb/usb_bsp.c \
	src/usb/usbd_midi_core.c \
	src/library/STM32_USB_OTG_Driver/src/usb_core.c \
	src/library/STM32_USB_OTG_Driver/src/usb_hcd.c \
	src/library/STM32_USB_OTG_Driver/src/usb_hcd_int.c \
	src/library/STM32_USB_HOST_Library/Core/src/usbh_core.c \
	src/library/STM32_USB_HOST_Library/Core/src/usbh_hcs.c \
	src/library/STM32_USB_HOST_Library/Core/src/usbh_ioreq.c \
	src/library/STM32_USB_HOST_Library/Core/src/usbh_stdreq.c \
	src/library/STM32_USB_HOST_Library/Class/MSC/src/usbh_msc_core.c \
	src/library/STM32_USB_HOST_Library/Class/MSC/src/usbh_msc_bot.c \
	src/library/STM32_USB_HOST_Library/Class/MSC/src/usbh_msc_scsi.c \
	src/library/STM32_USB_HOST_Library/Class/MSC/src/usbh_msc_fatfs.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_usart.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rng.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/misc.c \
	src/library/STM32_USB_OTG_Driver/src/usb_dcd.c \
	src/library/STM32_USB_OTG_Driver/src/usb_dcd_int.c \
	src/library/STM32_USB_Device_Library/Core/src/usbd_core.c \
	src/library/STM32_USB_Device_Library/Core/src/usbd_ioreq.c \
	src/library/STM32_USB_Device_Library/Core/src/usbd_req.c \
	src/third/system_stm32f4xx.c \
	src/utils/Hexter.cpp \
	src/utils/RingBuffer.cpp \
	src/hardware/LiquidCrystal.cpp \
	src/hardware/Menu.cpp \
	src/hardware/FMDisplay.cpp \
	src/hardware/Encoders.cpp \
	src/filesystem/ComboBank.cpp \
	src/filesystem/ConfigurationFile.cpp \
	src/filesystem/DX7SysexFile.cpp \
	src/filesystem/PatchBank.cpp \
	src/filesystem/ScalaFile.cpp \
	src/filesystem/Storage.cpp \
	src/filesystem/FileSystemUtils.cpp \
	src/filesystem/PreenFMFileType.cpp \
	src/filesystem/UserWaveform.cpp \
	src/midi/MidiDecoder.cpp \
	src/synth/Env.cpp \
	src/synth/Lfo.cpp \
	src/synth/LfoEnv.cpp \
	src/synth/LfoEnv2.cpp \
	src/synth/LfoOsc.cpp \
	src/synth/LfoStepSeq.cpp \
	src/synth/Matrix.cpp \
	src/synth/Osc.cpp \
	src/synth/Presets.cpp \
	src/synth/Synth.cpp \
	src/synth/SynthMenuListener.cpp \
	src/synth/SynthParamListener.cpp \
	src/synth/SynthStateAware.cpp \
	src/synth/SynthState.cpp \
	src/synth/Voice.cpp \
	src/synth/Timbre.cpp \
	src/synth/Common.cpp \
	src/library/fat_fs/src/ff.c \
	src/library/fat_fs/src/fattime.c  \
	src/midipal/note_stack.cpp \
	src/midipal/event_scheduler.cpp \


include_cvin_files:=
ifeq ($(MAKECMDGOALS),pfmcv)
    include_cvin_files = yes
endif
ifeq ($(MAKECMDGOALS),pfmcvo)
    include_cvin_files = yes
endif
ifdef include_cvin_files
SRC_FIRMWARE+=src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_adc.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.c \
	src/hardware/CVIn.cpp 
endif


SRC_BOOTLOADER:=src/bootloader/BootLoader.cpp \
	src/bootloader/usb_storage_usr.c \
	src/bootloader/usbd_storage_desc.c \
	src/bootloader/usbd_storage.c \
	usr/usb/usbKey_usr.c \
	usr/usb/usb_bsp.c \
	src/hardware/Encoders.cpp \
	src/hardware/LiquidCrystal.cpp \
	src/filesystem/Storage.cpp \
	src/filesystem/FirmwareFile.cpp \
	src/synth/Common.cpp \
	src/third/system_stm32f4xx.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.c   \
	src/library/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_usart.c \
	src/library/fat_fs/src/ff.c \
	src/library/fat_fs/src/fattime.c \
	src/library/STM32_USB_OTG_Driver/src/usb_core.c \
	src/library/STM32_USB_OTG_Driver/src/usb_hcd.c \
	src/library/STM32_USB_OTG_Driver/src/usb_hcd_int.c \
	src/library/STM32_USB_OTG_Driver/src/usb_dcd.c \
	src/library/STM32_USB_OTG_Driver/src/usb_dcd_int.c 	\
	src/library/STM32_USB_HOST_Library/Core/src/usbh_core.c \
	src/library/STM32_USB_HOST_Library/Core/src/usbh_hcs.c \
	src/library/STM32_USB_HOST_Library/Core/src/usbh_ioreq.c \
	src/library/STM32_USB_HOST_Library/Core/src/usbh_stdreq.c \
	src/library/STM32_USB_HOST_Library/Class/MSC/src/usbh_msc_core.c \
	src/library/STM32_USB_HOST_Library/Class/MSC/src/usbh_msc_bot.c \
	src/library/STM32_USB_HOST_Library/Class/MSC/src/usbh_msc_scsi.c \
	src/library/STM32_USB_HOST_Library/Class/MSC/src/usbh_msc_fatfs.c \
	src/library/STM32_USB_Device_Library/Core/src/usbd_core.c \
	src/library/STM32_USB_Device_Library/Core/src/usbd_ioreq.c \
	src/library/STM32_USB_Device_Library/Core/src/usbd_req.c \
	src/library/STM32_USB_Device_Library/Class/msc/src/usbd_msc_bot.c \
	src/library/STM32_USB_Device_Library/Class/msc/src/usbd_msc_core.c \
	src/library/STM32_USB_Device_Library/Class/msc/src/usbd_msc_data.c \
	src/library/STM32_USB_Device_Library/Class/msc/src/usbd_msc_scsi.c \
	src/library/STM32F4xx_StdPeriph_Driver/src/misc.c

INCLUDESDIR := -I./src/third/ -I./src/library/STM32_USB_HOST_Library/Class/MSC/inc -I./src/library/STM32_USB_HOST_Library/Core/inc -I./src/library/STM32_USB_OTG_Driver/inc -I./src/library/fat_fs/inc -I./src/library/STM32_USB_Device_Library/Core/inc -I./src/library/STM32_USB_Device_Library/Class/midi/inc -I./src/library/STM32F4xx_StdPeriph_Driver/inc/ -I./src/library/CMSIS/Include/ -I./src/utils/ -I./src/filesystem -I./src/hardware -I./src/usb -I./src/synth -I./src/midi -I./src/midipal -I./src -I./src/library/STM32_USB_Device_Library/Class/msc/inc
SMALLBINOPTS := -mfpu=fpv4-sp-d16 -ffunction-sections -fdata-sections -fno-rtti -fno-exceptions  -Wl,--gc-sections

#
DEFINE := -DPFM2_VERSION=${PFM2_VERSION} -DPFM2_BOOTLOADER_VERSION=${PFM2_BOOTLOADER_VERSION}

CFLAGS = -Ofast $(INCLUDESDIR) -c -fno-common   -g  -mthumb -mcpu=cortex-m4 -mfloat-abi=hard $(SMALLBINOPTS) $(DEFINE) -fsigned-char
AFLAGS  = -ahls -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16
LFLAGS  = -Tlinker/stm32f4xx.ld  -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -gc-sections    --specs=nano.specs
LFLAGS_BOOTLOADER  = -Tlinker_bootloader/stm32f4xx.ld  -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -gc-sections --specs=nano.specs
CPFLAGS = -Obinary

STARTUP := build/startup_firmware.o
STARTUP_BOOTLOADER := build/startup_bootloader.o
OBJDIR:=./build/

OBJTMP_FIRMWARE=$(addprefix $(OBJDIR),$(notdir $(SRC_FIRMWARE:.c=.o)))
OBJ_FIRMWARE=$(OBJTMP_FIRMWARE:.cpp=.o)

OBJTMP_BOOTLOADER := $(addprefix $(OBJDIR),$(notdir $(SRC_BOOTLOADER:.c=.o)))
OBJ_BOOTLOADER := $(OBJTMP_BOOTLOADER:.cpp=.o)


all:
	@echo "You must chose a target "
	@echo "Don't forget to clean between different build targets"
	@echo "   clean : clean build directory"
	@echo "   pfm : build pfm2 firmware"
	@echo "   pfmo : build pfm2 overclocked firmware"
	@echo "   pfmcv : build pfm2 firmware for Eurorack "
	@echo "   pfmcvo : build pfm2 overclocked firmware for Eurorack"
	@echo "   installdfu : flash last compiled firmware through DFU"
	@echo "   zip : create zip with all inside"

zip: 
	echo "dfu-util -a0 -d 0x0483:0xdf11 -D p2_${PFM2_VERSION_NUMBER}.bin -s 0x8040000" > build/install_firmware.cmd
	echo "dfu-util -a0 -d 0x0483:0xdf11 -D p2_${PFM2_VERSION_NUMBER}o.bin -s 0x8040000" > build/install_firmware_overclocked.cmd
	echo "dfu-util -a0 -d 0x0483:0xdf11 -D p2_cv_${PFM2_VERSION_NUMBER}.bin -s 0x8040000" > build/install_firmware_cv.cmd
	echo "dfu-util -a0 -d 0x0483:0xdf11 -D p2_cv_${PFM2_VERSION_NUMBER}o.bin -s 0x8040000" > build/install_firmware_cv_overclocked.cmd
	cp bootloader/* build/
	zip pfm2_$(PFM2_VERSION_NUMBER).zip build/*.bin build/*.syx build/*.cmd


pfm: binfirmware
pfmo: CFLAGS += -DOVERCLOCK
pfmo: binfirmware
pfmcv: CFLAGS += -DCVIN
pfmcv: binfirmware
pfmcvo: CFLAGS += -DOVERCLOCK
pfmcvo: CFLAGS += -DCVIN
pfmcvo: binfirmware

boot: CFLAGS += -DBOOTLOADER -I./src/bootloader -Os
boot: $(BIN_BOOTLOADER)

installdfu: 
	dfu-util -a0 -d 0x0483:0xdf11 -D $(file <.binfirmware) -s 0x8040000




binfirmware: elffirmware
	$(CP) -O binary $(ELF_FIRMWARE) $(BIN_FIRMWARE)
	ls -l $(BIN_FIRMWARE)
	$(file >.binfirmware,$(BIN_FIRMWARE))


elffirmware: $(OBJ_FIRMWARE) $(STARTUP)
	$(CC) $(LFLAGS) $^ -o ${ELF_FIRMWARE}
	arm-none-eabi-nm -l -S -n $(ELF_FIRMWARE) > $(SYMBOLS_FIRMWARE)
	arm-none-eabi-readelf -S $(ELF_FIRMWARE)

$(BIN_BOOTLOADER): $(ELF_BOOTLOADER)
	$(CP) -O binary $^ $(BIN_BOOTLOADER)
	ls -l $(BIN_BOOTLOADER)

$(ELF_BOOTLOADER): $(OBJ_BOOTLOADER) $(STARTUP_BOOTLOADER)
	$(CC) $(LFLAGS_BOOTLOADER) $^ -o $@
	arm-none-eabi-nm -l -S -n $(ELF_BOOTLOADER) > $(SYMBOLS_BOOTLOADER)
	arm-none-eabi-readelf -S $(ELF_BOOTLOADER)


$(STARTUP): linker/startup_stm32f4xx.s
	$(AS) $(AFLAGS) -o $(STARTUP) linker/startup_stm32f4xx.s > linker/startup_stm32f4xx.lst

$(STARTUP_BOOTLOADER): linker_bootloader/startup_stm32f4xx.s
	$(AS) $(AFLAGS) -o $(STARTUP_BOOTLOADER) linker_bootloader/startup_stm32f4xx.s > linker_bootloader/startup_stm32f4xx.lst


build/%.o: src/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $< -o $@

build/%.o: src/%.cpp
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) $< -o $@

build/%.o: src/bootloader/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -fpermissive $< -o $@

build/%.o: src/bootloader/%.cpp
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $< -o $@

build/%.o: src/usb/%.cpp
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $< -o $@

build/%.o: src/usb/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -fpermissive $< -o $@

build/%.o: src/third/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $< -o $@

build/%.o: src/synth/%.cpp
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $< -o $@

build/%.o: src/hardware/%.cpp
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $< -o $@

build/%.o: src/filesystem/%.cpp
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $< -o $@

build/%.o: src/midi/%.cpp
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $< -o $@

build/%.o: src/utils/%.cpp
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) $< -o $@

build/%.o: src/library/STM32_USB_OTG_Driver/src/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -fpermissive $< -o $@

build/%.o: src/library/STM32_USB_HOST_Library/Core/src/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -fpermissive $< -o $@

build/%.o: src/library/STM32_USB_HOST_Library/Class/MSC/src/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -fpermissive $< -o $@

build/%.o: src/library/STM32_USB_Device_Library/Core/src/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -fpermissive $< -o $@

build/%.o: src/library/STM32_USB_Device_Library/Class/msc/src/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -fpermissive $< -o $@

build/%.o: src/library/STM32F4xx_StdPeriph_Driver/src/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -fpermissive $< -o $@

build/%.o: src/library/fat_fs/src/%.c
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS) -fpermissive $< -o $@

build/%.o: src/midipal/%.cpp
	@echo "Compiling $<..."
	@$(CC) $(CFLAGS)  $< -o $@


clean:
	@ echo ".clean"
	rm -f *.lst build/*.o pfm2_$(PFM2_VERSION_NUMBER).zip

cleanall:
	@ echo ".clean all"
	rm -rf *.lst build/*
