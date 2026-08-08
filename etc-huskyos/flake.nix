{
  inputs.huskyos.url = github:tromshusky/huskyos-3;
  outputs = { huskyos, self, ... }: huskyos.withSelf self;
}
