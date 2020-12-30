class Heading < ApplicationRecord
  belongs_to :member

  def search_connections(searcher, expert)
    connections_string = String.new(" -> #{expert.name}")
    connection_ids = [expert.id]

    # End with the expert and work out
    friend_queue = [expert]
    searched_friends = [expert]

    while friend_queue.length > 0 do
      friend = friend_queue.shift # Cycle to the next member
      friend.friends.each do |next_friend|
        unless searched_friends.include? next_friend # Skip if already searched
          friend_queue << next_friend
          searched_friends << next_friend
          connection_ids << next_friend.id
        end
      end
    end

    # Remove any connections that are dead ends in the path
    revised_ids = connection_ids.reverse
    removed_ids = []

    revised_ids.each_cons(2) do |id, next_id|
      unless removed_ids.include?(id) # Skip IDs we've already removed
        member = Member.find(id)

        # Test the friend relationships and remove the false positives
        if member.id == searcher.id || searcher.friends.where(id: id).any?
          # this one's good, the next one might not be though..
          unless member.friends.where(id: next_id).any?
            removed_ids << next_id
            revised_ids.delete(next_id)
          end
        elsif !member.friends.where(id: next_id).any?
          removed_ids << id
          revised_ids.delete(id)
        end
      end
    end

    # Remove the searcher ID since it's loaded in the UI; and the expert ID since it was added first
    revised_ids.delete(searcher.id)
    revised_ids.delete(expert.id)

    revised_ids.reverse.each do |id|
      # Make the list readable
      connections_string.prepend(" -> #{Member.find(id).name}")
    end

    connections_string
  end
end
