deviceTypesCommon = require '@resin.io/device-types/common'
{ networkOptions, commonImg, instructions } = deviceTypesCommon

postProvisioningInstructions = [
	instructions.BOARD_SHUTDOWN
	instructions.REMOVE_INSTALL_MEDIA
	instructions.BOARD_REPOWER
]

module.exports =
	version: 1
	slug: 'cybertan-ze250'
	aliases: [ 'ZE250' ]
	name: 'Cybertan ZE250'
	arch: 'i386'
	state: 'preview'

	stateInstructions:
		postProvisioning: postProvisioningInstructions

	instructions: [
		instructions.ETCHER_USB
		instructions.EJECT_USB
		instructions.FLASHER_WARNING
    instructions.CONNECT_AND_BOOT
	].concat(postProvisioningInstructions)

	gettingStartedLink:
		windows: 'http://docs.resin.io/#/pages/installing/gettingStarted-ZE250.md#windows'
		osx: 'http://docs.resin.io/#/pages/installing/gettingStarted-ZE250.md#on-mac-and-linux'
		linux: 'http://docs.resin.io/#/pages/installing/gettingStarted-ZE250.md#on-mac-and-linux'

	yocto:
		machine: 'intel-quark'
		image: 'resin-image-flasher'
		fstype: 'resinos-img'
		version: 'yocto-jethro'
		deployArtifact: 'resin-image-flasher-intel-quark.resinos-img'
		compressed: true

	configuration:
		config:
			partition:
				primary: 1
			path: '/config.json'

	options: [ networkOptions.group ]

	initialization: commonImg.initialization
