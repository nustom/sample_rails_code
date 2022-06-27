##
# When the pdf_splitter converts a PDF into pages,
# this job will use the AutoTaggingService to process
# each page using Google OCR (optical character recognition)
# and then assign the results to an evidence page provided
class AutoTaggingJob
  @queue = :auto_tagging_queue
  def self.perform(evidence_page_id)
    AutoTaggingService.new(evidence_page_id).run
  end
end
