class ProcessCsvController < ApplicationController
  require 'csv'
  require 'ZipFileGenerator.rb'
  def index
  end

  def import
	file = params[:file]
	dZip = "tmp/csvExports"
	dFZip = dZip + ".zip"
	FileUtils.rm_rf(dZip)
	FileUtils.mkdir_p(dZip)
	#@filecsv = SmarterCSV.process(file.path).uniq! { |a| a.first }
	puts file.path
	@filecsv = CSV.read(file.path).uniq! { |a| a.first }
	@filecsv = @filecsv.uniq! { |a| a[3]}
	header = @filecsv.first
	numRows = params[:numFiles]
	numRows = numRows[:num].to_i
	cant_rows_per_file = numRows;
	numFiles = @filecsv.size/cant_rows_per_file
	
	for i in 0..numFiles
		nameFile = dZip.to_s + "/clear" + i.to_s + ".csv"
		CSV.open(nameFile,"wb") do |csv|
			start_row = cant_rows_per_file*i+1
			end_row = cant_rows_per_file*(i+1)
			csv << header
			if i < numFiles
				for j in start_row..end_row
					csv << @filecsv[j]
				end
			elsif
				for j in start_row..@filecsv.size-1
					csv << @filecsv[j]
				end
			end
		end
	end
	zf = ZipFileGenerator.new(dZip,dFZip)
	zf.write()
	send_file dFZip
	FileUtils.rm_rf(dZip)
  end
end
