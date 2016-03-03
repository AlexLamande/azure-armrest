# Azure namespace
module Azure
  module Armrest
    class BillingService < ArmrestService

      def initialize(armrest_configuration, options = {})
        super(armrest_configuration, nil, 'Microsoft.Commerce', options)
      end

      def list_rate_card(offer_durable_id, currency, locale, region_info)
        filter = build_filter(offer_durable_id, currency, locale, region_info)
        service = 'RateCard'
        url = build_url(service, filter)
        pp url
        response = rest_get(url)
        JSON.parse(response.body)
      end

      def list_usage(report_start_date, report_end_date, granularity,
                     show_details, continuation_token = nil)
        service = 'UsageAggregates'
        url = build_url(service)
        url << "&reportedStartTime=#{report_start_date}" unless report_start_date.nil?
        url << "&reportedEndTime=#{report_end_date}" unless report_end_date.nil?
        url << "&aggregationGranularity=#{granularity}" unless granularity.nil?
        url << "&showDetails=#{show_details}" unless show_details.nil?
        url << "&continuationToken=#{continuation_token}" unless continuation_token.nil?

        response = rest_get(url)
        JSON.parse(response.body)
      end

      def build_url(service, filter=nil)
        sub_id = armrest_configuration.subscription_id

        url =
          File.join(
            Azure::Armrest::COMMON_URI,
            sub_id,
            'providers',
            provider,
            service
          )

        url << "?api-version=#{@api_version}"
        url << "&$filter=#{filter}" unless filter.nil?

        url
      end

      def build_rate_card_filter(offer_durable_id, currency, locale, region_info)
        s = "OfferDurableId eq '#{offer_durable_id}'"
        s << "and Currency eq '#{currency}'"
        s << "and Locale eq '#{locale}'"
        s << "and RegionInfo eq '#{region_info}'"

        s
      end
    end
  end
end
