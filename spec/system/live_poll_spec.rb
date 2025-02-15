# frozen_string_literal: true

require 'rails_helper'

describe 'Live Poll', :js do
  before do
    allow(GoodJob).to receive_messages(retry_on_unhandled_error: false, preserve_job_records: true)
  end

  it 'reloads the dashboard when active' do
    # Load the page with live poll enabled
    visit 'good_job?poll=1'
    expect(page).to have_checked_field('live_poll')

    # Verify that the page reloads
    last_updated = page.find_by_id('page-updated-at')['datetime']
    wait_until(max: 10) do
      expect(last_updated).not_to eq(page.find_by_id('page-updated-at')['datetime'])
    end

    # Disable live polling and verify that the page does not reload
    uncheck('live_poll')
    last_updated = page.find_by_id('page-updated-at')['datetime']
    sleep 5
    expect(last_updated).to eq(page.find_by_id('page-updated-at')['datetime'])

    # Re-enable live polling and verify it is reloading again
    check('live_poll')
    last_updated = page.find_by_id('page-updated-at')['datetime']
    wait_until do
      expect(last_updated).not_to eq(page.find_by_id('page-updated-at')['datetime'])
    end
  end
end
