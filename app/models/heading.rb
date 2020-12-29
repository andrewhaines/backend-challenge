class Heading < ApplicationRecord
  belongs_to :member

  def search_connections(searcher, expert)
    connections_string = String.new
    connection_ids = []
    connection_ids << expert.id

    friend_queue = []
    searched_friends = []

    # End with the expert and work out
    friend_queue << expert
    searched_friends << expert
    connections_string.concat(" -> #{expert.name}")

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
    revised_ids = connection_ids.reverse.drop(1)

    revised_ids.each_cons(2) do |id, next_id|
      member = Member.find(id)

      # Test the friend relationship and remove the false positive
      unless member.friends.where(id: next_id).any?
        revised_ids.delete(next_id)
      end
    end

    revised_ids.delete(searcher.id)

    revised_ids.reverse.drop(1).each do |id|
      # Make it readable
      connections_string.prepend(" -> #{Member.find(id).name}")
    end

    connections_string
  end
end
