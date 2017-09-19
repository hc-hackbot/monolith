module V1
  module SlackInvitation
    class WebhookController < ApplicationController
      def create
        @invite = SlackInvite.find invitation_id
        if @invite.nil?
          render json: {invite: nil}, status: 422
          return
        end

        unless slack_invite_url
          render json: {invite: nil}, status: 422
          return
        end

        @invite.slack_invite_id = slack_invite_id

        @invite.update({state: @invite.class::STATE_INVITE_RECEIVED })

        SlackSignUpJob.perform_now(@invite.id)
      end

      private

      def slack_invite_id
        slack_invite_url.match(/\/invite\/(\w+)\?/)[1]
      end

      def slack_invite_url
        Nokogiri::HTML(body_html)
          .xpath('//a')
          .find {|l| l.text.strip == "Join Now"}
          .try { |l| l['href'] }
      end

      def invitation_id
        recipient.match(/slack\+(\d+)\@mail\.hackclub\.com/)[1].to_i
      end

      def body_html
        params["body-html"]
      end

      def recipient
        params["recipient"]
      end
    end
  end
end
