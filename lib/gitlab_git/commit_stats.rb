# Gitlab::Git::CommitStats counts the additions, deletions, and total changes
# in a commit.
module Gitlab
  module Git
    class CommitStats

      attr_reader :id, :additions, :deletions, :total

      # Instantiate a CommitStats object
      def initialize(raw_commit)
        @id = raw_commit.oid
        @additions = 0
        @deletions = 0
        @total = 0

        raw_commit.parents[0].diff(raw_commit).each_patch{ |p|
          # TODO: Use the new Rugged convenience methods when they're released
          @additions += p.stat[0]
          @deletions += p.stat[1]
          @total += p.changes
        }

      end
    end
  end
end
