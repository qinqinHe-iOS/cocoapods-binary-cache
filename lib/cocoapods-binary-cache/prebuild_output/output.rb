# Copyright 2019 Grabtaxi Holdings PTE LTE (GRAB), All rights reserved.
# Use of this source code is governed by an MIT-style license that can be found in the LICENSE file

module PodPrebuild
  class Output
    def initialize(prebuild_sandbox)
      @sandbox = prebuild_sandbox
    end

    def prebuild_delta_path
      @prebuild_delta_path ||= PodPrebuild::Config.instance.prebuild_delta_path
    end

    def delta_dir
      @delta_dir ||= File.dirname(prebuild_delta_path)
    end

    def clean_delta_file
      puts "Clean delta file: #{prebuild_delta_path}"
      FileUtils.rm_rf(prebuild_delta_path)
    end

    def create_dir_if_needed(dir)
      FileUtils.mkdir_p dir unless File.directory?(dir)
    end

    # Input 2 arrays of library names
    def write_delta_file(updated, deleted)
      if updated.empty? && deleted.empty?
        Pod::UI.puts "No changes in prebuild"
        return
      end

      Pod::UI.puts "Write prebuild changes to: #{prebuild_delta_path}"
      create_dir_if_needed(delta_dir)
      changes = PodPrebuild::JSONFile.new(prebuild_delta_path)
      changes["updated"] = updated
      changes["deleted"] = deleted
      changes.save!
    end
  end
end
