# DryObjectMapper

Transform your ActiveRecord objects into Dry::Struct DTO objects.
Benefits of returning a DTO instead of an ActiveRecord object from your services:
1. It makes our code more readable, we know exactly what fields we are returning, with type safety.
2. It allows us to render the response in any format with ease.
3. It prevents us from accessing the Data Layer directly from the Presentation Layer, rather than going through the 
Service Layer, preventing accidental queries when accessing data in the views.
4. It works with other tools that i have built, like dry-swagger, which transforms our DTO's into a valid 
and up to date swagger documentation, with type definitions.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dry_object_mapper'
```

And then execute:

    bundle install

## Usage

Lets say we have the following Dry::Struct definitions:

    class Model3Dto < Dry::Struct
      attribute :description, Types::String
    end

    class Model2Dto < Dry::Struct
      attribute :name, Types::String
    end

    class Model1Dto < Dry::Struct
      attribute :id, Types::String
      attribute :age, Types::Integer
      attribute :model2_dto, Model2Dto
      attribute :model3_dto, Types::Array.of(Model3Dto)
    end
    
    DryObjectMapper::Mapper.call(model.all, Model1Dto)
    => [
            #<Model1Dto id="22bf569c-f47e-473a-a821-a41b23dae927" 
                        age=25 
                        model2_dto=#<Model2Dto name="Name">
                        model3_dto=[#<Model3Dto description="Description" >]
            >
        ]

If we want to add data that is not present in the model objects, we can pass options as an argument to the call method:

    class Model1Dto < Dry::Struct
      attribute :id, Types::String
      attribute :age, Types::Integer
      attribute :some_counter, Types::Integer
      attribute :model2_dto, Model2Dto
      attribute :model3_dto, Types::Array.of(Model3Dto)
    end

    DryObjectMapper::Mapper.call(model.all, Model1Dto, { some_counter: 10 })
    => [
            #<Model1Dto id="22bf569c-f47e-473a-a821-a41b23dae927" 
                        age=25 
                        some_counter=10
                        model2_dto=#<Model2Dto name="Name">
                        model3_dto=[#<Model3Dto description="Description" >]
            >
        ]

For nested data, pass it as a hash:

    class Model2Dto < Dry::Struct
      attribute :name, Types::String
      attribute :some_counter, Types::Integer
    end

    class Model1Dto < Dry::Struct
      attribute :id, Types::String
      attribute :age, Types::Integer
      attribute :model2_dto, Model2Dto
      attribute :model3_dto, Types::Array.of(Model3Dto)
    end

    DryObjectMapper::Mapper.call(model.all, Model1Dto, { model2_dto: { some_counter: 10 } })
    => [
            #<Model1Dto id="22bf569c-f47e-473a-a821-a41b23dae927" 
                        age=25 
                        model2_dto=#<Model2Dto name="Name" some_counter=10 >
                        model3_dto=[#<Model3Dto description="Description" >]
            >
        ]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dry_object_mapper. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dry_object_mapper/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DryObjectMapper project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dry_object_mapper/blob/main/CODE_OF_CONDUCT.md).
