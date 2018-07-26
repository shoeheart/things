# frozen_string_literal: true

Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 15
Delayed::Worker.max_attempts = 1
Delayed::Worker.max_run_time = 10.minutes
Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = "batch"
Delayed::Worker.delay_jobs = !Rails.env.test?
# Delayed::Worker.raise_signal_exceptions = :term
# Delayed::Worker.raise_signal_exceptions = false
Delayed::Worker.logger =
  Logger.new(File.join(Rails.root, "log", "delayed_job.log"))
Delayed::Worker.queue_attributes = {
  batch: { priority: 10 },
  interactive: { priority: 5 },
  immediate: { priority: 0 }
}
