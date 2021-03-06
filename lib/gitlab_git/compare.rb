module Gitlab
  module Git
    class Compare
      attr_reader :commits, :same, :head, :base

      def initialize(repository, base, head)
        @commits = []
        @same = false
        @repository = repository

        return unless base && head

        @base = Gitlab::Git::Commit.find(repository, base.try(:strip))
        @head = Gitlab::Git::Commit.find(repository, head.try(:strip))

        return unless @base && @head

        if @base.id == @head.id
          @same = true
          return
        end

        @commits = Gitlab::Git::Commit.between(repository, @base.id, @head.id)
      end

      def diffs(options = {})
        unless @head && @base
          return Gitlab::Git::DiffCollection.new([])
        end

        paths = options.delete(:paths) || []
        Gitlab::Git::Diff.between(@repository, @head.id, @base.id, options, *paths)
      end
    end
  end
end
