#!/usr/bin/env zsh

for i (0 1) {
	(( $i == 1 )) && () {
		[[ -d ${1} ]] && open -a ${1}
	} "$(xcode-select -p)/Applications/Simulator.app" && sleep 5

	irb <<-EOF
		require 'plist'

		config_path = File.join(File.expand_path("~"), "Library", "Preferences", "com.apple.iphonesimulator.plist")
		sim_runtime = 'com.apple.CoreSimulator.SimRuntime'
		last_scale_prefix = 'SimulatorWindowLastScale-'
		tmp_path = "/tmp/com.apple.iphonesimulator-#{rand(10001)}.plist.xml"
		File.write(tmp_path, File.read(config_path))
		system("plutil -convert xml1 #{tmp_path}")
		result = Plist.parse_xml(tmp_path)
		File.delete(tmp_path)

		Plist.parse_xml(
			File.join(
				File.expand_path('~'), 'Library', 'Developer',
				'CoreSimulator', 'Devices', '.default_created.plist'
			)
		).map { |key,value|
			key.start_with?(sim_runtime) ? value.keys.map { |key| last_scale_prefix + key } : []
		}.concat(
			result.keys.select { |key| key.start_with?(last_scale_prefix + sim_runtime) }
		).flatten.uniq.each do |key|
			puts("defaults write '#{config_path}' '#{key}' '1.0'")
		end
	EOF
}
