@echo off
echo 'dowloading ECCC data'

cd "C:\Users\Maria\Desktop\VCR Dashboard\"
python.exe "C:\Users\Maria\Desktop\VCR Dashboard\DownloadClimate_2.0.py"

echo 'downloading Nasa Power files'

"C:\Program Files\R\R-4.1.1\bin\Rscript.exe" "C:\Users\Maria\Desktop\VCR Dashboard\download_nasapowerfiles.R"

TIMEOUT /T 20

echo 'updating or generating vcr_dashboard_data.csv"

"C:\Program Files\R\R-4.1.1\bin\Rscript.exe" "C:\Users\Maria\Desktop\VCR Dashboard\update_vcr_dashboard.R"

echo 'update complete'

TIMEOUT/T 5

exit