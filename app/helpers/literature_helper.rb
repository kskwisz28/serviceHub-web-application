module LiteratureHelper

  def thumbnail(asset_url)
    pdf_filename = File.basename(asset_url, ".*")
    "literature/#{pdf_filename}-thumbnail.png"
  end
end
